import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const storedState = localStorage.getItem('search-history');
const startingState = storedState ? JSON.parse(storedState) : [['tinder', '']];

const app = Main.embed(document.getElementById('root'), {
  history: startingState
});

app.ports.toGoogleAnalytics.subscribe(function(str) {
  gtag('event', 'search', {
    search_term: str
  });
});

app.ports.setStorage.subscribe(function(history) {
  localStorage.setItem('search-history', JSON.stringify(history));
});

registerServiceWorker();
