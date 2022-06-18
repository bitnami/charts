/// <reference types="cypress" />
import { random } from "./utils";

it("allows user to log in and log out", () => {
  cy.login();
  cy.contains("Invalid user name or password").should("not.exist");
  cy.contains("button", "admin").click();
  cy.contains("Log Out").click();
  cy.get("#login_username");
});

it("allows creating a project", () => {
  cy.login();
  cy.visit("/harbor/projects");
  cy.fixture("projects").then((project) => {
    cy.contains("button", "New Project").click();
    cy.get("#create_project_name").type(`${project.newProject.name}-${random}`);
    cy.contains("button", "OK").should("not.be.disabled").click();
    cy.contains("Created project successfully");
  });
});

it("allows creating a registry", () => {
  cy.login();
  cy.visit("/harbor/registries");
  cy.fixture("registries").then((registry) => {
    cy.contains("button", "New Endpoint").click();
    cy.get("#adapter").select(`${registry.newRegistry.provider}`);
    cy.get("#destination_name").type(`${registry.newRegistry.name}-${random}`);
    cy.contains("button", "OK").should("not.be.disabled").click();
    cy.contains(".datagrid-table", `${registry.newRegistry.name}-${random}`);
  });
});

it("allows launching a vulnerability scan", () => {
  const IMAGE_SCANNER = "Trivy";
  cy.login();
  cy.visit("/harbor/interrogation-services/scanners");
  cy.contains(".datagrid-table", IMAGE_SCANNER);
  cy.contains("a", "Vulnerability").click();
  cy.contains("SCAN NOW").click();
  cy.contains("Trigger scan all successfully");
});

it("checks system configurations endpoint", () => {
  cy.request({
    method: "GET",
    url: "/api/v2.0/configurations",
    form: true,
    auth: {
      username: Cypress.env("username"),
      password: Cypress.env("password"),
    },
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.body).to.include.all.keys(
      "auth_mode",
      "email_host",
      "project_creation_restriction",
      "scan_all_policy",
      "self_registration"
    );
  });
});
