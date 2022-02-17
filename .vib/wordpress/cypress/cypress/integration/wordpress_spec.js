/// <reference types="cypress" />

it('contains the sample blogpost and a comment', () => {
  cy.visit('/');
  cy.get('.wp-block-query').should('exist');
  cy.get('.wp-block-post-title a').click();
  cy.fixture('helloworld').then((hw) => {
    cy.get('.wp-block-post-title').should('have.text', hw.title);
    cy.get('.wp-block-post-content').should('contain.text', hw.content);
  })

  cy.get('.wp-block-post-title').click();
  cy.get('.commentlist').should('have.length', 1);
  cy.fixture('helloworld').then((hw) => {
    cy.get('.comment-author').should('contain.text', hw.commenter)

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

it('disallows login to an invalid user', () => {
  cy.clearCookies();
  cy.visit('/wp-login.php')
  cy.fixture('user').then((user) => {
    cy.get('#user_login').type(user.username).should('have.value', user.username);
    cy.get('#user_pass').type(user.password).should('have.value', user.password);
  })
  cy.get('#wp-submit').click();
  cy.fixture('user').then((user) => {
    cy.get('#login_error').should('contain.text', `The username ${user.username} is not registered on this site.`);
  })

})

it('disallows login to a valid user with wrong password', () => {
  cy.clearCookies();
  cy.visit('/wp-login.php')

  cy.get('#user_login').type(Cypress.env('username')).should('have.value', Cypress.env('username'));
  cy.fixture('user').then((user) => {
    cy.get('#user_pass').type(user.password).should('have.value', user.password);
  })
  cy.get('#wp-submit').click();
  cy.get('#login_error').should('contain.text', `Error: The password you entered for the username ${Cypress.env('username')} is incorrect. Lost your password?`);
})

it('checks the blog name and user email configuration', () => {
  cy.login();
  cy.visit('/wp-admin/options-general.php')
  cy.get('#new_admin_email').should('have.value', Cypress.env('wordpressEmail'));
  cy.get('#blogname').should('have.value', Cypress.env('wordpressBlogname'));
})

it('checks if admin can edit a site', () => {
  cy.login();
  cy.visit('/wp-admin/index.php')
  cy.contains('Open site editor').click()
  cy.url().should('include', '/wp-admin/site-editor.php');
})

it('checks if admin can edit a post', () => {
  cy.login();
  cy.visit('/wp-admin/edit.php');
  cy.get('#bulk-action-selector-top').should('exist');
  cy.get('#post-1 .row-title').should('exist').click();
  cy.url().should('include', '/post.php?post=1&action=edit');
  cy.get('#editor').should('exist');
})

it('checks the SMTP configuration', () => {
  cy.login();
  cy.visit('/wp-admin/admin.php?page=wp-mail-smtp');
  cy.get('div').contains('WP Mail SMTP').should('be.visible');
  cy.get('#wp-mail-smtp-setting-smtp-host').should('have.value', Cypress.env('smtpMailServer'));
  cy.get('#wp-mail-smtp-setting-smtp-port').should('have.value', Cypress.env('smtpPort'));
  cy.get('#wp-mail-smtp-setting-smtp-user').should('have.value', Cypress.env('smtpUser'));
  cy.get('#wp-mail-smtp-setting-from_name').should('have.value', `${Cypress.env('wordpressFirstName')} ${Cypress.env('wordpressLastName')}`);
})

it('checks the value of auto update status', () => {
  cy.login();
  cy.visit("/wp-admin/update-core.php");
  cy.get('.auto-update-status').should('contain.text', 'This site is automatically kept up to date with maintenance and security releases of WordPress only.');
})

it('allows the upload of a file',() => {
  cy.login();
  cy.visit("wp-admin/upload.php");
  cy.get("[role='button']").contains('Add New').click();
  cy.get("[aria-labelledby]").contains('Select Files').should('be.visible');
  cy.get('input[type=file]').selectFile('cypress/fixtures/images/test_image.jpeg',
    {force:true});
  cy.get('.attachment').should('be.visible');
})

it('allows to log out', () => {
  cy.login();
  cy.get("#wp-admin-bar-logout .ab-item").click({
    force: true
  });
  cy.get('.message').contains('logged out');
})

