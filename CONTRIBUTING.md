# Contributing to Shooter Carnival

First off, thank you for considering contributing! We're thrilled you're here. This project is made by the community, for the community, and we welcome contributions of all sizes.

By participating in this project, you agree to abide by our [Code of Conduct](CODE_OF_CONDUCT.md) (coming soon!).

## How Can I Contribute?

There are many ways to contribute, and all of them are valuable:

*   **Reporting Bugs:** Find something that doesn't work right? Let us know by [opening an issue](https://github.com/HouZenKai/ShooterCarnival/issues/new/choose).
*   **Suggesting Enhancements:** Have a great idea for a new feature, power-up, or enemy? We'd love to hear it.
*   **Writing Code:** Fixing bugs or implementing new features is a fantastic way to help.
*   **Graphics:** Creating sprites, backgrounds and other visual assets for feasting the eyes.
*   **Audio:** Creating sound effects, background music that excites and immerse people.


### Your First Code Contribution

Unsure where to begin? We've made it easy!

1.  Go to the [Issues tab](https://github.com/HouZenKai/ShooterCarnival/issues).
2.  Filter the list by the label **`good first issue`**.
3.  These are tasks that we've identified as being perfect for new contributors. Pick one that looks interesting, leave a comment that you'd like to work on it, and we'll assign it to you!
4.  Check the [Kanban tab](https://github.com/orgs/HouZenKai/projects/3/views/1) to see all tasks in a kanban.  [What is kanban](https://www.youtube.com/watch?v=qp7Wc6ba_fc)

## Development Setup

Ready to write some code, add a sound effect, a graphic or music that you created? Here’s how to get the project running on your local machine.

1.  **Install Godot:** Download and install the latest stable version of the **Godot Engine (version 4.x)**. You can get it for free from the [official website](https://godotengine.org/download/).

2.  **Fork the Repository:** Click the "Fork" button at the top right of the [Shooter Carnival GitHub page](https://github.com/HouZenKai/ShooterCarnival). This creates a copy of the project under your own GitHub account.

3.  **Clone Your Fork:** Open a terminal or command prompt and run the following command, replacing `YOUR-USERNAME` with your GitHub username:
    ```bash
    git clone https://github.com/YOUR-USERNAME/ShooterCarnival.git
    ```

4.  **Open the Project in Godot:**
    *   Launch the Godot Engine.
    *   In the Project Manager, click the "Import" button.
    *   Navigate to the `ShooterCarnival/Src` folder you just cloned and select the `project.godot` file.
    *   The project will now appear in your project list. Double-click it to open.

You're all set! You can now run the game and start making changes or adding assets.

## Contribution Workflow

1.  **Create a New Branch:** Before you start contributing, create a new branch for your changes. This keeps your work organized.
    ```bash
    git checkout -b your-feature-or-fix-name
    ```

2.  **Make Your Changes:** Write your code, create your assets, and save your work in the Godot editor.

3.  **Commit Your Changes:** Once you're happy with your changes, commit them with a clear and descriptive message.
    ```bash
    git add .
    git commit -m "feat: Implement the Laser weapon power-up"
    ```
    *(We recommend using a convention like `feat:`, `fix:`, or `docs:` to start your commit messages.)*

4.  **Push to Your Fork:** Push your new branch up to your fork on GitHub.
    ```bash
    git push origin your-feature-or-fix-name
    ```

5.  **Open a Pull Request:** Go to your fork on GitHub. You'll see a prompt to "Compare & pull request". Click it, give your PR a clear title and description, and submit it for review!

---

## Foundational Knowledge - Recommended Learning

New to Godot? No problem! We've gathered some of the best tutorials to help you understand the core concepts we use in this project. The "Hook" of our project is that **if you know Python, you can write GDScript!** These resources will bridge the gap.

We also point to specific tutorials relevant to work being done in the current Sprint.

### Getting Started
*   **Core Tutorial:** Godot Docs - Your First 2D Game (Dodge the Creeps). This is the "Hello, World!" of Godot and is the best place to start.
    *   [https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html](https://docs.godotengine.org/en/stable/getting_started/first_2d_game/index.html)

### Fundamental Godot Concepts
*   **Nodes & Scenes:** The basic building blocks of every Godot game.
    *   Scene Instancing & Composition: [https://docs.godotengine.org/en/stable/getting_started/step_by_step/scenes_and_nodes.html](https://docs.godotengine.org/en/stable/getting_started/step_by_step/scenes_and_nodes.html)
    *   Parent-Child Relationships: [https://www.youtube.com/watch?v=y3k9Cx-ifII](https://www.youtube.com/watch?v=y3k9Cx-ifII) (GDQuest)
    *   Scene Inheritance: [https://docs.godotengine.org/en/stable/tutorials/scripting/scene_inheritance.html](https://docs.godotengine.org/en/stable/tutorials/scripting/scene_inheritance.html)

*   **Scripting & Logic:**
    *   `_process` vs `_physics_process`: [https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html](https://docs.godotengine.org/en/stable/tutorials/scripting/idle_and_physics_processing.html)
    *   Export Variables for Easy Tweaking: [https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/basics.html#exports](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/basics.html#exports)
    *   Vector Math Essentials: [https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html](https://docs.godotengine.org/en/stable/tutorials/math/vector_math.html)

*   **Communication Between Nodes:** This is key for making different parts of the game talk to each other.
    *   Signals (The Godot Way): [https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html)
    *   Using Node Groups: [https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html](https://docs.godotengine.org/en/stable/tutorials/scripting/groups.html)

Thank you again for your interest in **Shooter Carnival**. We can't wait to see what you build!