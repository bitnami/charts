export interface RealTypeOptions {
    /**
     * Delay after each keypress (ms)
     * @default 25
     */
    delay?: number;
    /**
     * Delay between keyDown and keyUp events (ms)
     * @default 15
     */
    pressDelay?: number;
    /**
     * Displays the command in the Cypress command log
     * @default true
     */
    log?: boolean;
}
/** @ignore this, update documentation for this function at index.d.ts */
export declare function realType(text: string, options?: RealTypeOptions): Promise<void>;
