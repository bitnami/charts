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

package de.adorsys.keycloak.config.service;

import de.adorsys.keycloak.config.model.CustomImport;
import de.adorsys.keycloak.config.model.RealmImport;
import de.adorsys.keycloak.config.provider.KeycloakProvider;
import de.adorsys.keycloak.config.repository.ClientRepository;
import org.keycloak.admin.client.resource.ClientResource;
import org.keycloak.admin.client.resource.RealmResource;
import org.keycloak.admin.client.resource.RoleResource;
import org.keycloak.representations.idm.ClientRepresentation;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CustomImportService {
    private static final Logger logger = LoggerFactory.getLogger(CustomImportService.class);

    private final KeycloakProvider keycloakProvider;

    private final ClientRepository clientRepository;

    @Autowired
    public CustomImportService(KeycloakProvider keycloakProvider, ClientRepository clientRepository) {
        this.keycloakProvider = keycloakProvider;
        this.clientRepository = clientRepository;
    }

    public void doImport(RealmImport realmImport) {
        CustomImport customImport = realmImport.getCustomImport();

        if (customImport == null) {
            return;
        }
        setupImpersonation(realmImport, customImport);
    }

    private void setupImpersonation(RealmImport realmImport, CustomImport customImport) {
        if (customImport.isRemoveImpersonation()) {
            removeImpersonation(realmImport);
        }
    }

    private void removeImpersonation(RealmImport realmImport) {
        RealmResource master = keycloakProvider.getInstance().realm("master");

        String clientId = realmImport.getRealm() + "-realm";
        List<ClientRepresentation> foundClients = master.clients()
                .findByClientId(clientId);

        if (!foundClients.isEmpty()) {
            removeImpersonationRoleFromClient(master, clientId);
        }
    }

    private void removeImpersonationRoleFromClient(RealmResource master, String clientId) {
        ClientRepresentation client = clientRepository.getByClientId("master", clientId);
        ClientResource clientResource = master.clients()
                .get(client.getId());

        RoleResource impersonationRole = clientResource.roles().get("impersonation");

        try {
            logger.debug("Remove role 'impersonation' from client '{}' in realm 'master'", clientId);

            impersonationRole.remove();
        } catch (javax.ws.rs.NotFoundException e) {
            logger.info("Cannot remove 'impersonation' role from client '{}' in 'master' realm: Not found", clientId);
        }
    }
}
