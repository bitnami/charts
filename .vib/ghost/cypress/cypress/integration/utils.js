/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export const getPageUrlFromTitle = (title) => {
  return '/'.concat(title.toLocaleLowerCase().replace(' ', '-'));
};

export const getUserFromEmail = (email = Cypress.env('email')) => {
  return email.substring(0, email.indexOf('@'));
};
