interface Window {
    plugin: Plugin;
}

interface Plugin {
    Fabric: Fabric;
}

declare var plugin: Plugin;

interface Fabric {
    Digits: Digits;
}

interface Digits {
    login(arg?: string): Promise<DigitsToken>;
    logout(): Promise<void>;
    getToken(): Promise<DigitsToken>;
}

type DigitsToken = {
    token: string,
    secret: string
}
