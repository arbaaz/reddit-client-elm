import './main.css';
import { Main } from './Main.elm';
import registerServiceWorker from './registerServiceWorker';

const storedState = localStorage.getItem('persistModel') || {};
const initialState = JSON.parse(storedState);
const app = Main.embed(document.getElementById('root'), initialState);

app.ports.toGoogleAnalytics.subscribe(function(str) {
  gtag('event', 'search', {
    search_term: str
  });
});

app.ports.setStorage.subscribe(function(history) {
  history.history = history.history.reduce((acc, [k, v]) => {
    if (k !== '') {
      acc[k] = v;
    }

    return acc;
  }, {});

  localStorage.setItem('persistModel', JSON.stringify(history));
});

registerServiceWorker();
