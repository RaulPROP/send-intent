import { IonContent, IonHeader, IonPage, IonTitle, IonToolbar } from '@ionic/react';
import React from 'react';
import ExploreContainer from '../components/ExploreContainer';
import './Home.css';

import { SendIntent } from 'send-intent';

const Home: React.FC = () => {

    function checkIntent() {
        SendIntent.checkSendIntentReceived().then((result: any) => (async function (result: any) {
            alert(JSON.stringify(result, null, 4));
        })(result)).catch((error:any) => {
          alert(JSON.stringify({error}, null, 4));
        })
    }

    window.addEventListener("sendIntentReceived", () => {
        checkIntent();
    })

    checkIntent();

    return (
    <IonPage>
      <IonHeader>
        <IonToolbar>
          <IonTitle>Blank</IonTitle>
        </IonToolbar>
      </IonHeader>
      <IonContent>
        <IonHeader collapse="condense">
          <IonToolbar>
            <IonTitle size="large">Blank</IonTitle>
          </IonToolbar>
        </IonHeader>
        <ExploreContainer />
      </IonContent>
    </IonPage>
  );
};

export default Home;
