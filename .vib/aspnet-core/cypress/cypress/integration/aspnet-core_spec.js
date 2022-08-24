/// <reference types="cypress" />

it('renders application correctly', () => {
  cy.request('/').then((response) => {
    expect(response.status).to.eq(200);
    expect(response.headers['content-type']).to.eq('text/plain; charset=utf-8');
    expect(response.body).to.contain('Hello World');
  });
});
