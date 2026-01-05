# PROJECT STRUCTURE

## ASSETS

The assets folders will contain our image and audio files

## COMPONENTS

Features like health, damage, movement, etc. that can be reused differently in more than one scene we call components, because we use composition to build behaviour

## ENTITIES

An entity is a set that contains all parts of an element of the game, for example: ship script, ship scene, ship sprites

## SCENES

Here we have the higher level scenes that represent the gameplay, it is composed the entities (elements) of the game, i.e.: intro scene, main scene, stage 1 scene, stage 1 boss scene, game over scene, leaderboard scene.

## SCRIPTS

Keep scripts that are generic here, like utility and helper functions.