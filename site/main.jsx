import "./style.css";
import javascriptLogo from "./javascript.svg";
import viteLogo from "/vite.svg";
import { handleFileInputChange, handleImageSaved } from "./image_uploader.js";
import { Image } from "image-js";

const imageElementId = "image_element_id";

const fileInputId = "file_input_id";
const localStorageKey = "image";
const submitButton = "compute_theme";

const handleSubmit = (button) => {
  document.querySelector(button).addEventListener("click", () => {
    const domImage = document.querySelector(`#${imageElementId}`);
    Image.load(domImage.src).then((image) => {
      console.log("channels", image.channels);
    });
  });
};

const setupThemer = () => {
  handleFileInputChange(`#${fileInputId}`);
  handleImageSaved(`#${imageElementId}`);
  handleSubmit(`#${submitButton}`);
};

document.querySelector("#app").innerHTML = `
  <div class="container">
    <div class="uploadedImage">
      <img src="${javascriptLogo}" id="${imageElementId}"/>
    </div>
    <div class="controls">
    <input type="file" id="${fileInputId}"/>
    <button id="${submitButton}">Compute Theme</button>
  </div>
  </div>
`;

setupThemer();
