import "./main.css";
import { Main } from "./Main.elm";
import registerServiceWorker from "./registerServiceWorker";

const storedState = localStorage.getItem("search-history");
const startingState = storedState ? JSON.parse(storedState) : "tinder";

const app = Main.embed(document.getElementById("root"), startingState);

app.ports.toJs.subscribe(function(str) {
  console.log("got from Elm:", str);
  gtag("event", "search", {
    search_term: str
  });
});

app.ports.setStorage.subscribe(function(history) {
  console.log("History", history);
  localStorage.setItem("search-history", JSON.stringify(history.join("_")));
});

registerServiceWorker();
