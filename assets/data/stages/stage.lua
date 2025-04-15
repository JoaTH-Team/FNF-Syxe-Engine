function create()
    setProperty("defaultCamZoom", 0.85)
    setProperty("curStage", "stage")

    createSprite("bg", {-600, -200}, "stageback")
    setScrollFactor("bg", 0.9)
    setScrollFactor("bg", 0.9)
    add("bg")

    createSprite("stageFront", {-650, 600}, "stagefront")
    setScrollFactor("stageFront", 0.9)
    setScrollFactor("stageFront", 0.9)
    add("stageFront")

    createSprite("stageCurtains", {-500, -300}, "stagecurtains")
    setScrollFactor("stageCurtains", 1.3)
    setScrollFactor("stageCurtains", 1.3)
    add("stageCurtains")
end