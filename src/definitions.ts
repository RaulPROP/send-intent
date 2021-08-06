export interface Intent {
  text?: string;
  uri?: string;
  type?: string;
}

export interface SendIntentPlugin {
  checkSendIntentReceived(): Promise<Intent>;
}
