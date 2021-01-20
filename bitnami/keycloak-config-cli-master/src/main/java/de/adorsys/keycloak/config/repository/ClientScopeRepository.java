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
import de.adorsys.keycloak.config.util.ResponseUtil;
import org.keycloak.admin.client.resource.ClientScopeResource;
import org.keycloak.admin.client.resource.ClientScopesResource;
import org.keycloak.admin.client.resource.ProtocolMappersResource;
import org.keycloak.representations.idm.ClientScopeRepresentation;
import org.keycloak.representations.idm.ProtocolMapperRepresentation;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.stream.Collectors;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.Response;

@Service
public class ClientScopeRepository {

    private final RealmRepository realmRepository;

    @Autowired
    public ClientScopeRepository(RealmRepository realmRepository) {
        this.realmRepository = realmRepository;
    }

    public List<ClientScopeRepresentation> getAll(String realmName) {
        ClientScopesResource clientScopeResource = realmRepository.getResource(realmName).clientScopes();
        return clientScopeResource.findAll();
    }

    public List<ClientScopeRepresentation> getListByNames(String realmName, List<String> clientScopeNames) {
        return clientScopeNames
                .stream()
                .map(scopeName -> getByName(realmName, scopeName))
                .collect(Collectors.toList());
    }

    public ClientScopeRepresentation getByName(String realmName, String clientScopeName) {
        ClientScopeResource clientScopeResource = getResourceByName(realmName, clientScopeName);
        if (clientScopeResource == null) {
            return null;
        }
        return clientScopeResource.toRepresentation();
    }

    public ClientScopeRepresentation getById(String realmName, String clientScopeId) {
        ClientScopeResource clientScopeResource = getResourceById(realmName, clientScopeId);
        if (clientScopeResource == null) {
            return null;
        }
        return clientScopeResource.toRepresentation();
    }

    public void create(String realmName, ClientScopeRepresentation clientScope) {
        Response response = realmRepository.getResource(realmName).clientScopes().create(clientScope);
        ResponseUtil.validate(response);
    }

    public void delete(String realmName, String id) {
        ClientScopeResource clientScopeResource = getResourceById(realmName, id);
        clientScopeResource.remove();
    }

    public void update(String realmName, ClientScopeRepresentation clientScope) {
        ClientScopeResource clientScopeResource = getResourceById(realmName, clientScope.getId());
        clientScopeResource.update(clientScope);
    }

    public void addProtocolMappers(String realmName, String clientScopeId, List<ProtocolMapperRepresentation> protocolMappers) {
        ClientScopeResource clientScopeResource = getResourceById(realmName, clientScopeId);
        ProtocolMappersResource protocolMappersResource = clientScopeResource.getProtocolMappers();

        for (ProtocolMapperRepresentation protocolMapper : protocolMappers) {
            Response response = protocolMappersResource.createMapper(protocolMapper);
            ResponseUtil.validate(response);
        }
    }

    public void removeProtocolMappers(String realmName, String clientScopeId, List<ProtocolMapperRepresentation> protocolMappers) {
        ClientScopeResource clientScopeResource = getResourceById(realmName, clientScopeId);
        ProtocolMappersResource protocolMappersResource = clientScopeResource.getProtocolMappers();

        List<ProtocolMapperRepresentation> existingProtocolMappers = clientScopeResource.getProtocolMappers().getMappers();
        List<ProtocolMapperRepresentation> protocolMapperToRemove = existingProtocolMappers.stream()
                .filter(em -> protocolMappers.stream()
                        .anyMatch(m -> Objects.equals(m.getName(), em.getName()))
                )
                .collect(Collectors.toList());

        for (ProtocolMapperRepresentation protocolMapper : protocolMapperToRemove) {
            protocolMappersResource.delete(protocolMapper.getId());
        }
    }

    public void updateProtocolMappers(String realmName, String clientScopeId, List<ProtocolMapperRepresentation> protocolMappers) {
        ClientScopeResource clientScopeResource = getResourceById(realmName, clientScopeId);
        ProtocolMappersResource protocolMappersResource = clientScopeResource.getProtocolMappers();

        for (ProtocolMapperRepresentation protocolMapper : protocolMappers) {
            try {
                protocolMappersResource.update(protocolMapper.getId(), protocolMapper);
            } catch (WebApplicationException error) {
                String errorMessage = ResponseUtil.getErrorMessage(error);
                throw new ImportProcessingException(
                        "Cannot update protocolMapper '" + protocolMapper.getName()
                                + "' for clientScope '" + clientScopeResource.toRepresentation().getName()
                                + "' in realm '" + realmName + "'"
                                + ": " + errorMessage,
                        error
                );
            }
        }
    }

    private ClientScopeResource getResourceByName(String realmName, String clientScopeName) {
        Optional<ClientScopeRepresentation> maybeClientScope = searchByName(realmName, clientScopeName);

        ClientScopeRepresentation existingClientScope = maybeClientScope.orElse(null);

        if (existingClientScope == null) {
            return null;
        }

        return getResourceById(realmName, existingClientScope.getId());
    }

    private ClientScopeResource getResourceById(String realmName, String clientScopeId) {
        return realmRepository.getResource(realmName).clientScopes().get(clientScopeId);
    }

    public Optional<ClientScopeRepresentation> searchByName(String realmName, String clientScopeName) {
        ClientScopesResource clientScopeResource = realmRepository.getResource(realmName).clientScopes();

        return clientScopeResource.findAll()
                .stream()
                .filter(s -> Objects.equals(s.getName(), clientScopeName))
                .findFirst();
    }

    public List<ClientScopeRepresentation> getDefaultClientScopes(String realmName) {
        List<ClientScopeRepresentation> defaultClientScopes = new ArrayList<>();

        defaultClientScopes.addAll(realmRepository.getResource(realmName).getDefaultDefaultClientScopes());
        defaultClientScopes.addAll(realmRepository.getResource(realmName).getDefaultOptionalClientScopes());

        return defaultClientScopes;
    }
}
