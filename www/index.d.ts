interface DigitsConnectPlugin {
    login(arg?: string): Promise<DigitsConnectToken>;
    logout(): Promise<void>;
    getToken(): Promise<DigitsConnectToken>;
}

type DigitsConnectToken = {
    token: string,
    secret: string
}
