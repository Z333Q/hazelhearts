const app = new PIXI.Application({
  width: 800,
  height: 600,
  backgroundColor: 0x1099bb,
});
document.body.appendChild(app.view);

const waterElement = document.getElementById('water');
const fertilizerElement = document.getElementById('fertilizer');

const resources = {
  water: 100,
  fertilizer: 100,
};

PIXI.Loader.shared
  .add('farm_bg', 'assets/images/farm_background.png')
  .add('avatar', 'assets/images/avatar.png')
  .add('tree', 'assets/images/tree.png')
  .add('upgraded_tree', 'assets/images/upgraded_tree.png')
  .load(setup);

function setup() {
  const farm_bg = new PIXI.Sprite(PIXI.Loader.shared.resources.farm_bg.texture);
  app.stage.addChild(farm_bg);

  const avatar = new PIXI.Sprite(PIXI.Loader.shared.resources.avatar.texture);
  avatar.anchor.set(0.5);
  avatar.x = app.view.width / 2;
  avatar.y = app.view.height / 2;
  app.stage.addChild(avatar);

  const tree = new PIXI.Sprite(PIXI.Loader.shared.resources.tree.texture);
  tree.anchor.set(0.5);
  tree.x = 200;
  tree.y = 300;
  app.stage.addChild(tree);

  document.addEventListener('keydown', (event) => {
    if (event.code === 'ArrowLeft') {
      avatar.x -= 5;
    } else if (event.code === 'ArrowRight') {
      avatar.x += 5;
    } else if (event.code === 'KeyW') {
      if (resources.water > 0) {
        resources.water -= 1;
        waterElement.textContent = resources.water;
      }
    } else if (event.code === 'KeyF') {
      if (resources.fertilizer > 0) {
        resources.fertilizer -= 1;
        fertilizerElement.textContent = resources.fertilizer;
      }
    } else if (event.code === 'KeyU') {
      upgradeTree();
    }
  });
}

function upgradeTree() {
  if (resources.fertilizer >= 20) {
    resources.fertilizer
