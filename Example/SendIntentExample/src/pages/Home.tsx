import React, { Component } from 'react';

import { Intent, SendIntent } from 'send-intent';
import { Filesystem } from '@capacitor/filesystem';
import FileViewer from 'react-file-viewer';

type HomeProps = {};

const SAFE_AREA_PADDING = "env(safe-area-inset-top, 0px) env(safe-area-inset-right, 0px) env(safe-area-inset-bottom, 0px) env(safe-area-inset-left, 0px) !important";

interface HomeState {
  somethingShared: boolean;
  uri: string;
  readerType: string;
  mimeType: string;
  fileData: string;
  text: string;
}

class Home extends Component<HomeProps, HomeState> {

  constructor(props: HomeProps) {
    super(props);

    this.state = { somethingShared: false, uri: "", text: "", mimeType: "", readerType: "", fileData: "" };
  }

  public async checkIntent() {
    try {
      const intent = await SendIntent.checkSendIntentReceived();
      this.handleIntent(intent);
    } catch (error) {
      console.error(error);
    }
  }

  componentDidMount() {
    this.checkIntent();

    window.addEventListener("sendIntentReceived", () => {
      this.checkIntent();
    })
  }

  private handleIntent(intent: Intent): void {
    console.log(JSON.stringify(intent));
    const uri = encodeURI(intent.uri || '');
    const type = intent.type || '';
    const text = intent.text || '';
    if (intent.uri !== '') {
      this.handleUriIntent(uri, type);
    } else if (text !== '') {
      this.handleTextIntent(text);
    }
  }

  private async handleUriIntent(uri: string, type: string): Promise<void> {
    const readerType = this.mimetype2Readertype(type);
    console.log(`${type} -> ${readerType}`);
    try {
      const file = await Filesystem.readFile({ path: uri });
      const dataPath = "data:" + type + ";base64, " + file.data;
      this.setState({ somethingShared: true, uri, text: "", mimeType: type, readerType: readerType, fileData: dataPath });
    } catch (error) {
      console.error(error);
    }
  }

  private handleTextIntent(text: string): void {
    this.setState({ somethingShared: true, text, uri: '', mimeType: "", readerType: "", fileData: "" });
  }

  private mimetype2Readertype(mimetype: string): string {
    const validTypes = ['png', 'jpeg', 'jpg', 'gif', 'bmp', 'pdf', 'csv', 'xslx', 'docx', 'mp4', 'webm', 'mp3'];

    return validTypes.filter((type) => mimetype.includes(type))[0] || 'unknown';
  }
  
  public render(): JSX.Element {

    const content = this.state.somethingShared ? this.somethingSharedContent : this.nothingSharedContent;

    return (
      <div style={{"width": "100%", height: "100%", padding: SAFE_AREA_PADDING, boxSizing: "border-box"}}>
      
        { content }

      </div>
    );
  }

  private get nothingSharedContent(): JSX.Element {
    return (
      <h1>Share something to the app</h1>
    )
  }

  private get somethingSharedContent(): JSX.Element {
    const content = this.state.uri !== "" ? this.fileContent : this.textContent;
    return (
      <div>
        { content }
      </div>
    )
  }

  private get fileContent(): JSX.Element {
    return (
      <div>
        <h1>File: { this.state.uri }</h1>
        <h2>Type: { this.state.mimeType }</h2>
        <FileViewer
          fileType={this.state.readerType}
          filePath={this.state.fileData}
        />
      </div>
    )
  }

  private get textContent(): JSX.Element {
    return (
      <div>
        <h1>URL: { this.state.text }</h1>
        <iframe height="100%" width="100%" src={this.state.text} frameBorder="0"></iframe>
      </div>
    )
  }
};

export default Home;
