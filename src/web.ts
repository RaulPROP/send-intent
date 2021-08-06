import { WebPlugin } from '@capacitor/core';
import { Intent, SendIntentPlugin } from './definitions';

export class SendIntentWeb extends WebPlugin implements SendIntentPlugin {
  constructor() {
    super({
      name: 'SendIntent',
      platforms: ['web']
    });
  }

  async checkSendIntentReceived(): Promise<Intent> {
    return {};
  }

}
