/// <reference types="cypress" />

it('redirects to the auth provider login', () => {
  cy.visit('/', {failOnStatusCode:false})
  cy.contains('button', 'Sign in');

  cy.request({
    url: "/oauth2/start",
    method: "GET"
  }).then((response) => {
    expect(response.status).to.eq(200);
    expect(response.redirects).not.to.be.undefined;
    response.redirects.forEach(red => {
      expect(red).to.contains('google');
    });
  })
});
