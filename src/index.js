import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const storedState = localStorage.getItem('persistModel');
const startingState = storedState ? JSON.parse(storedState) : [['tinder', '']];

const app = Main.embed(document.getElementById('root'), {
  history: startingState,
  settings: { count: 10, gifMode: false }
});

app.ports.toGoogleAnalytics.subscribe(function(str) {
  gtag('event', 'search', {
    search_term: str
  });
});

app.ports.setStorage.subscribe(function(history) {
  localStorage.setItem('persistModel', JSON.stringify(history));
});

registerServiceWorker();
