/*-
 * ---license-start
 * keycloak-config-cli
 * ---
 * Copyright (C) 2017 - 2021 adorsys GmbH & Co. KG @ https://adorsys.com
 * ---
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 * ---license-end
 */

package de.adorsys.keycloak.config.repository;

import de.adorsys.keycloak.config.exception.ImportProcessingException;
import de.adorsys.keycloak.config.exception.KeycloakRepositoryException;
import de.adorsys.keycloak.config.util.ResponseUtil;
import org.keycloak.admin.client.resource.ClientResource;
import org.keycloak.admin.client.resource.ClientsResource;
import org.keycloak.admin.client.resource.ProtocolMappersResource;
import org.keycloak.representations.idm.ClientRepresentation;
import org.keycloak.representations.idm.ClientScopeRepresentation;
import org.keycloak.representations.idm.ProtocolMapperRepresentation;
import org.keycloak.representations.idm.RoleRepresentation;
import org.keycloak.representations.idm.authorization.PolicyRepresentation;
import org.keycloak.representations.idm.authorization.ResourceRepresentation;
import org.keycloak.representations.idm.authorization.ResourceServerRepresentation;
import org.keycloak.representations.idm.authorization.ScopeRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;

@Service
public class ClientRepository {

    private final RealmRepository realmRepository;

    @Autowired
    public ClientRepository(RealmRepository realmRepository) {
        this.realmRepository = realmRepository;
    }

    public Optional<ClientRepresentation> searchByClientId(String realmName, String clientId) {
        List<ClientRepresentation> foundClients = getResource(realmName).findByClientId(clientId);

        Optional<ClientRepresentation> client;
        if (foundClients.isEmpty()) {
            client = Optional.empty();
        } else {
            client = Optional.of(foundClients.get(0));
        }

        return client;
    }

    public ClientRepresentation getByClientId(String realmName, String clientId) {
        Optional<ClientRepresentation> foundClients = searchByClientId(realmName, clientId);

        if (!foundClients.isPresent()) {
            throw new KeycloakRepositoryException("Cannot find client by clientId '" + clientId + "'");
        }

        return foundClients.get();
    }

    public ClientRepresentation getById(String realmName, String id) {
        return getResourceById(realmName, id).toRepresentation();
    }

    public ResourceServerRepresentation getAuthorizationConfigById(String realmName, String id) {
        return getResourceById(realmName, id).authorization().exportSettings();
    }

    public String getClientSecret(String realmName, String clientId) {
        ClientResource clientResource = getResourceByClientId(realmName, clientId);
        return clientResource.getSecret().getValue();
    }

    public void create(String realmName, ClientRepresentation client) {
        try {
            Response response = getResource(realmName).create(client);
            ResponseUtil.validate(response);
        } catch (WebApplicationException error) {
            String errorMessage = ResponseUtil.getErrorMessage(error);

            throw new ImportProcessingException(
                    "Cannot create client '" + client.getClientId()
                            + "' in realm '" + realmName + "'"
                            + ": " + errorMessage,
                    error
            );
        }
    }

    public void update(String realmName, ClientRepresentation client) {
        ClientResource clientResource = getResourceById(realmName, client.getId());
        clientResource.update(client);
    }

    public void remove(String realmName, ClientRepresentation client) {
        ClientResource clientResource = getResourceById(realmName, client.getId());
        clientResource.remove();
    }

    private ClientsResource getResource(String realmName) {
        return realmRepository.getResource(realmName).clients();
    }

    public ClientResource getResourceById(String realmName, String id) {
        ClientResource client = getResource(realmName).get(id);

        if (client == null) {
            throw new KeycloakRepositoryException("Cannot find client by id '" + id + "'");
        }

        return client;
    }

    public ClientResource getResourceByClientId(String realmName, String clientId) {
        ClientRepresentation client = getByClientId(realmName, clientId);

        return getResourceById(realmName, client.getId());
    }

    public final Set<String> getAllIds(String realmName) {
        return getAll(realmName)
                .stream()
                .map(ClientRepresentation::getClientId)
                .collect(Collectors.toSet());
    }

    public final List<ClientRepresentation> getAll(String realmName) {
        return getResource(realmName).findAll();
    }

    public void addProtocolMappers(String realmName, String clientId, List<ProtocolMapperRepresentation> protocolMappers) {
        ClientResource clientResource = getResourceById(realmName, clientId);
        ProtocolMappersResource protocolMappersResource = clientResource.getProtocolMappers();

        for (ProtocolMapperRepresentation protocolMapper : protocolMappers) {
            Response response = protocolMappersResource.createMapper(protocolMapper);
            ResponseUtil.validate(response);
        }
    }

    public void removeProtocolMappers(String realmName, String clientId, List<ProtocolMapperRepresentation> protocolMappers) {
        ClientResource clientResource = getResourceById(realmName, clientId);
        ProtocolMappersResource protocolMappersResource = clientResource.getProtocolMappers();

        List<ProtocolMapperRepresentation> existingProtocolMappers = clientResource.getProtocolMappers().getMappers();
        List<ProtocolMapperRepresentation> protocolMapperToRemove = existingProtocolMappers.stream()
                .filter(em -> protocolMappers.stream()
                        .anyMatch(m -> Objects.equals(m.getName(), em.getName()))
                )
                .collect(Collectors.toList());

        for (ProtocolMapperRepresentation protocolMapper : protocolMapperToRemove) {
            protocolMappersResource.delete(protocolMapper.getId());
        }
    }

    public void updateProtocolMappers(String realmName, String id, List<ProtocolMapperRepresentation> protocolMappers) {
        ClientResource clientResource = getResourceById(realmName, id);
        ProtocolMappersResource protocolMappersResource = clientResource.getProtocolMappers();

        for (ProtocolMapperRepresentation protocolMapper : protocolMappers) {
            try {
                protocolMappersResource.update(protocolMapper.getId(), protocolMapper);
            } catch (WebApplicationException error) {
                String errorMessage = ResponseUtil.getErrorMessage(error);
                throw new ImportProcessingException(
                        "Cannot update protocolMapper '" + protocolMapper.getName()
                                + "' for client '" + clientResource.toRepresentation().getClientId()
                                + "' in realm '" + realmName + "'"
                                + ": " + errorMessage,
                        error
                );
            }
        }
    }

    public void updateAuthorizationSettings(String realmName, String id, ResourceServerRepresentation authorizationSettings) {
        ClientResource clientResource = getResourceById(realmName, id);
        clientResource.authorization().update(authorizationSettings);
    }

    public void createAuthorizationResource(String realmName, String id, ResourceRepresentation resource) {
        ClientResource clientResource = getResourceById(realmName, id);

        Response response = clientResource.authorization().resources().create(resource);
        ResponseUtil.validate(response);
    }

    public void updateAuthorizationResource(String realmName, String id, ResourceRepresentation resource) {
        ClientResource clientResource = getResourceById(realmName, id);
        clientResource.authorization().resources().resource(resource.getId()).update(resource);
    }

    public void removeAuthorizationResource(String realmName, String id, String resourceId) {
        ClientResource clientResource = getResourceById(realmName, id);
        clientResource.authorization().resources().resource(resourceId).remove();
    }

    public void addAuthorizationScope(String realmName, String id, String name) {
        ClientResource clientResource = getResourceById(realmName, id);

        Response response = clientResource.authorization().scopes().create(new ScopeRepresentation(name));
        ResponseUtil.validate(response);
    }

    public void updateAuthorizationScope(String realmName, String id, ScopeRepresentation scope) {
        ClientResource clientResource = getResourceById(realmName, id);
        clientResource.authorization().scopes().scope(scope.getId()).update(scope);
    }

    public void removeAuthorizationScope(String realmName, String id, String scopeId) {
        ClientResource clientResource = getResourceById(realmName, id);
        clientResource.authorization().scopes().scope(scopeId).remove();
    }

    public void createAuthorizationPolicy(String realmName, String id, PolicyRepresentation policy) {
        ClientResource clientResource = getResourceById(realmName, id);

        Response response = clientResource.authorization().policies().create(policy);
        ResponseUtil.validate(response);
    }

    public void updateAuthorizationPolicy(String realmName, String id, PolicyRepresentation policy) {
        ClientResource clientResource = getResourceById(realmName, id);
        clientResource.authorization().policies().policy(policy.getId()).update(policy);
    }

    public void removeAuthorizationPolicy(String realmName, String id, String policyId) {
        ClientResource clientResource = getResourceById(realmName, id);
        clientResource.authorization().policies().policy(policyId).remove();
    }

    public void addScopeMapping(String realmName, String clientId, String clientLevelId, List<RoleRepresentation> roles) {
        ClientResource clientResource = getResourceByClientId(realmName, clientId);
        clientResource
                .getScopeMappings()
                .clientLevel(clientLevelId)
                .add(roles);
    }

    public void removeScopeMapping(String realmName, String clientId, String clientLevelId, List<RoleRepresentation> roles) {
        ClientResource clientResource = getResourceByClientId(realmName, clientId);
        clientResource
                .getScopeMappings()
                .clientLevel(clientLevelId)
                .remove(roles);
    }

    public void addDefaultClientScopes(String realmName, String clientId,
                                       List<ClientScopeRepresentation> defaultClientScopes) {
        ClientResource clientResource = getResourceByClientId(realmName, clientId);

        for (ClientScopeRepresentation defaultClientScope : defaultClientScopes) {
            clientResource.addDefaultClientScope(defaultClientScope.getId());
        }
    }

    public void removeDefaultClientScopes(String realmName, String clientId,
                                          List<ClientScopeRepresentation> defaultClientScopes) {
        ClientResource clientResource = getResourceByClientId(realmName, clientId);

        for (ClientScopeRepresentation defaultClientScope : defaultClientScopes) {
            clientResource.removeDefaultClientScope(defaultClientScope.getId());
        }
    }

    public void addOptionalClientScopes(String realmName, String clientId,
                                        List<ClientScopeRepresentation> optionalClientScopes) {
        ClientResource clientResource = getResourceByClientId(realmName, clientId);

        for (ClientScopeRepresentation optionalClientScope : optionalClientScopes) {
            clientResource.addOptionalClientScope(optionalClientScope.getId());
        }
    }

    public void removeOptionalClientScopes(String realmName, String clientId,
                                           List<ClientScopeRepresentation> optionalClientScopes) {
        ClientResource clientResource = getResourceByClientId(realmName, clientId);

        for (ClientScopeRepresentation optionalClientScope : optionalClientScopes) {
            clientResource.removeOptionalClientScope(optionalClientScope.getId());
        }
    }
}
