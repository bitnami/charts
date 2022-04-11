<<<<<<< HEAD
const COMMAND_DELAY = 500;

for (const command of ['click']) {
    Cypress.Commands.overwrite(command, (originalFn, ...args) => {
        const origVal = originalFn(...args);

        return new Promise((resolve) => {
            setTimeout(() => {
                resolve(origVal);
            }, COMMAND_DELAY);
        });
    });
=======
const CLICK_DELAY = 1300;
const TYPE_DELAY = 300;

for (const command of ['click']) {
  Cypress.Commands.overwrite(command, (originalFn, ...args) => {
    const origVal = originalFn(...args);

    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(origVal);
      }, CLICK_DELAY);
    });
  });
}

for (const command of ['type']) {
  Cypress.Commands.overwrite(command, (originalFn, ...args) => {
    const origVal = originalFn(...args);

    return new Promise((resolve) => {
      setTimeout(() => {
        resolve(origVal);
      }, TYPE_DELAY);
    });
  });
>>>>>>> bitnami-master
}
