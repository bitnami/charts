Cypress.on('uncaught:exception', (err, runnable) => {
  if (err.message.includes('Cannot read properties of undefined') ||
    err.message.includes('is not a function')) {
    return false;
  }
});
