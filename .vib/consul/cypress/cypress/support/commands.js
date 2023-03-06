Cypress.on('uncaught:exception', (err, runnable, promise) => {
  if (
    err.message.includes('Cannot read properties of undefined') ||
    promise ||
    'is not a function'
  ) {
    return false;
  }
});
