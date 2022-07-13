import { keyCodeDefinitions } from "../keyCodeDefinitions";
export interface RealPressOptions {
    /**
     * Delay between keyDown and keyUp events (ms)
     * @default 10
     */
    pressDelay?: number;
    /**
     * Displays the command in the Cypress command log
     * @default true
     */
    log?: boolean;
}
declare type Key = keyof typeof keyCodeDefinitions;
declare type KeyOrShortcut = Key | Array<Key>;
/** @ignore this, update documentation for this function at index.d.ts */
export declare function realPress(keyOrShortcut: KeyOrShortcut, options?: RealPressOptions): Promise<void>;
export {};
