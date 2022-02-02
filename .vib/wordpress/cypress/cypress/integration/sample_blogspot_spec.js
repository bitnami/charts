/// <reference types="cypress" />
describe('Hello World post', () => {

  beforeEach(() => {
    cy.visit('/')
  })

  it('exists.', () => {
    cy.get('#post-1 .entry-title a').should('exist');
  })

  it('contains placeholder content.', () => {
    cy.get('#post-1 .entry-title a').click();
    cy.fixture('helloworld').then((hw) => {
      cy.get('.entry-title').should('have.text', hw.title);
      cy.get('.entry-content').should('contain.text', hw.content);
    })
  })

  it('contains sample comment.', () => {
    cy.get('#post-1 .entry-title a').click();
    cy.get('.comment-list').should('have.length', 1);
    cy.fixture('helloworld').then((hw) => {
      cy.get('#comment-1 .comment-author').should('contain.text', hw.commenter);
    })
  })

  it('has comment box.', () => {
    cy.get('#post-1 .entry-title a').click();
    cy.fixture('helloworld').then((hw) => {
      cy.get('#comment').type(hw.comment).should('have.value', hw.comment);
    })

    cy.fixture('user').then((user) => {
      cy.get('#author').type(user.username).should('have.value', user.username);
      cy.get('#email').type(user.email).should('have.value', user.email);
    })
    cy.get('#submit').click();
  })
})
