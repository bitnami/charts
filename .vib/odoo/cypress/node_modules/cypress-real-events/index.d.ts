type NormalizeCypressCommand<TFun> = TFun extends (
  subject: infer TSubject,
  ...args: infer TArgs
) => Promise<infer TReturn>
  ? (...args: TArgs) => Cypress.Chainable<TReturn>
  : TFun;

type NormalizeNonSubjectCypressCommand<TFun> = TFun extends (
  ...args: infer TArgs
) => Promise<infer TReturn>
  ? (...args: TArgs) => Cypress.Chainable<TReturn>
  : TFun;

declare namespace Cypress {
  interface Chainable {
    /**
     * Fires native system click event.
     * @see https://github.com/dmtrKovalenko/cypress-real-events#cyrealclick
     * @example
     * cy.get("button").realClick()
     * @param options click options
     */
    realClick: NormalizeCypressCommand<
      typeof import("./commands/realClick").realClick
    >;
    /**
     * Fires native touch event. It mimics the native touch gesture and can fire html5 touch events.
     * @see https://github.com/dmtrKovalenko/cypress-real-events#cyrealtouch
     * @example
     * cy.realTouch()
     * cy.realTouch({ position: "center" })
     * @param options touch options
     */
    realTouch: NormalizeCypressCommand<
      typeof import("./commands/realTouch").realTouch
    >;
    /**
     * Fires native hover event. Yes, it can test `:hover` preprocessor.
     * @see https://github.com/dmtrKovalenko/cypress-real-events#cyrealhover
     * @example
     * cy.get("button").realHover()
     * @param options hover options
     */
    realHover: NormalizeCypressCommand<
      typeof import("./commands/realHover").realHover
    >;
    /**
     * Fires native touch swipe event. Actually fires sequence of native events: touchStart -> touchMove[] -> touchEnd
     * @see https://github.com/dmtrKovalenko/cypress-real-events#cyrealhover
     * @example
     * cy.get("swipeableRoot").realSwipe("toLeft") // or toRight, toTop, toBottom
     * cy.get("swipeableRoot").realSwipe("toBottom", { length: 100, step: 10 })
     * @param options hover options
     */
    realSwipe: NormalizeCypressCommand<
      typeof import("./commands/realSwipe").realSwipe
    >;
    /**
     * Fires native press event. It can fire one key event or the "shortcut" like Shift+Control+M
     * @see https://github.com/dmtrKovalenko/cypress-real-events#cyrealpress
     * @example
     * cy.realPress("K")
     * cy.realPress(["Alt", "Meta", "P"]) // Alt+(Command or Control)+P
     * @param key key to type. Should be the same as cypress's default type command argument (https://docs.cypress.io/api/commands/type.html#Arguments)
     * @param options press options
     */
    realPress: NormalizeNonSubjectCypressCommand<typeof import("./commands/realPress").realPress>;
    /**
     * Runs a sequence of native press event (via cy.press)
     * Type event is global. Make sure that it is not attached to any field.
     * @see https://github.com/dmtrKovalenko/cypress-real-events#cyrealtype
     * @example
     * cy.get("input").realClick()
     * cy.realType("some text {enter}")
     * @param text text to type. Should be the same as cypress's default type command argument (https://docs.cypress.io/api/commands/type.html#Arguments)
     */
    realType: NormalizeNonSubjectCypressCommand<typeof import("./commands/realType").realType>;
    /**
     * Fires native system mousePressed event.
     * @see https://github.com/dmtrKovalenko/cypress-real-events#cyrealMouseDown
     * @example
     * cy.get("button").realMouseDown()
     */
    realMouseDown: NormalizeCypressCommand<
      typeof import("./commands/mouseDown").realMouseDown
    >;
    /**
     * Fires native system mouseReleased event.
     * @see https://github.com/dmtrKovalenko/cypress-real-events#cyrealMouseUp
     * @example
     * cy.get("button").realMouseUp()
     */
    realMouseUp: NormalizeCypressCommand<
      typeof import("./commands/mouseUp").realMouseUp
    >;
    /**
    * Fires native system mouseMoved event.
    * Moves mouse inside a subject to the provided amount of coordinates from top left corner (adjustable with position option.)
    * @see https://github.com/dmtrKovalenko/cypress-real-events#cyrealMouseMove
    * @example
    * cy.get("button").realMouseUp()
    */
    realMouseMove: NormalizeCypressCommand<
      typeof import("./commands/mouseMove").realMouseMove
    >;
  }
}
