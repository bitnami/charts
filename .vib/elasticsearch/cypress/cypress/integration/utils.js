/// <reference types="cypress" />

export let random = (Math.random() + 1).toString(36).substring(7);

export let randomNumber = (Math.floor(Math.random() * 10000) + 10000)
  .toString()
  .substring(1);
