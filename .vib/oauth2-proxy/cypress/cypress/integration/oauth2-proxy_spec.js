/// <reference types="cypress" />

it('redirects to the auth provider login', () => {
  // Access to the URL without proper identification results in a forbidden response
  // with the UI to log in.
  cy.visit('/', {failOnStatusCode:false})
  cy.contains('button', 'Sign in');

  // Unfortunately, a third-party auth provider service (like Google, Facebook, OpenID connector, ...)
  // is needed to test the identification process, which is difficult to configure for the tests.
  //
  // Hence, the test focuses on asserting that a redirection to the default auth provider (Google) is
  // performed.
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
