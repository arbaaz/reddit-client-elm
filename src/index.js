import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const storedState = localStorage.getItem('persistModel');
const initialState = storedState
  ? JSON.parse(storedState)
  : {
      history: { tinder: '' },
      settings: {
        count: '10',
        gifMode: false,
        imageMode: true,
        autoPlayGif: false,
        adultMode: false
      }
    };

const app = Main.embed(document.getElementById('root'), initialState);

app.ports.toGoogleAnalytics.subscribe(function(str) {
  gtag('event', 'search', {
    search_term: str
  });
});

app.ports.setStorage.subscribe(function(history) {
  console.log('History', history);
  localStorage.setItem('persistModel', JSON.stringify(history));
});

registerServiceWorker();
