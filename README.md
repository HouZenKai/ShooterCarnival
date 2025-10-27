<img src='docs/image/ShooterCarnival.png'>

# Welcome to Shooter Carnival!

**Have you ever dreamed of building your own video game? Do you have fond memories of classic arcade shoot-'em-ups like *Gradius*, *R-Type*, *Twin Bee*, and *Galaga*? Then you've come to the right place.**

**Shooter Carnival** is a community-driven effort to build a spectacular, feature-rich 2D shoot-'em-up that serves as a playable love letter to the golden age of arcade games. We're creating a game that's not only fun to play but also incredibly fun and rewarding to build, together.

### The Mission: Learn, Build, and Play

Our goal is to create an open-source game where anyone, from absolute beginners to seasoned developers, can contribute meaningfully. This is a "Public Goods" project where the reward is what you create, what you learn, and the community you join.

*   **Build your portfolio:** Every merged pull request is a concrete addition to your development experience.
*   **Learn Godot & GDScript:** We provide a structured path with tutorials to help you learn one of the most exciting and user-friendly game engines available.
*   **Have fun:** We're making a game! The process should be as enjoyable as the final product.

### You Can Make a Game!

Worried about learning a new language? Don't be. We're using the **Godot Engine** with **GDScript**, a language so similar to Python that you'll feel right at home. If you are learning Python this a great opportunity to solidify your learning.

```gdscript
# This is GDScript. Looks familiar, right?
var speed = 400
var can_shoot = true

func _process(delta):
    var velocity = Vector2.ZERO
    if Input.is_action_pressed("move_right"):
        velocity.x += 1
    # ... and so on!
```

We've specifically designed our initial tasks to be incredibly welcoming to developers with a Python background. You can jump in and start contributing from day one.

### A Clear Roadmap to Success

This isn't a chaotic project that will fizzle out. We have a detailed development plan broken down into **Epics and Sprints**. Every feature, from the player's first shot to complex boss battles and weapon systems, is mapped out. You can see our progress, find a task that interests you, and know exactly how your contribution fits into the bigger picture.

### Your First Contribution is Waiting

Ready to join us? It's easier than you think.

1.  Check out our **[CONTRIBUTING.md](CONTRIBUTING.md)** guide for simple setup instructions (coming soon!).
2.  Head over to our **[Issues Tab](https://github.com/HouZenKai/ShooterCarnival/issues)** and look for a label called `good first issue`.
3.  Grab an issue, make your change, and submit a pull request.

**No contribution is too small.** Whether you're fixing a typo, adding a sound effect, or implementing a new weapon system, your work is valued and will be immortalized in our `CONTRIBUTORS.md` file and the game's credits.

Let's build something amazing together!