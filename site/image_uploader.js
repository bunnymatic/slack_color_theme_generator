const imageSavedEvent = "localStorage.image.persisted";

const saveImage = (path) => {
  const destKey = `mrthemer.image`;
  const reader = new FileReader();
  reader.addEventListener(
    "load",
    () => {
      localStorage.setItem(destKey, reader.result);
      const event = new CustomEvent(imageSavedEvent, {
        detail: { key: destKey },
      });
      document.dispatchEvent(event);
    },
    false
  );
  if (path) {
    reader.readAsDataURL(path);
  }
};

const getImage = (key) => localStorage.getItem(key);

const handleFileInputChange = (inputSelector) => {
  const fileInput = document.querySelector(inputSelector);
  fileInput.addEventListener("change", (e) => {
    saveImage(e.target.files[0]);
  });
};

const handleImageSaved = (imageSelector) => {
  document.addEventListener(imageSavedEvent, (event) => {
    const img = document.querySelector(imageSelector);
    img.src = getImage(event.detail.key);
  });
};

export { handleImageSaved, handleFileInputChange };
