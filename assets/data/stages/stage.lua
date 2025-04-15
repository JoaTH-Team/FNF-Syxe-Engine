function create()
    setProperty("defaultCamZoom", 0.85)
    setProperty("curStage", "stage")

    createSprite("bg", {-600, -200}, "stageback")
    setProperty("bg.scrollFactor.x", 0.9)
    setProperty("bg.scrollFactor.y", 0.9)
    add("bg")

    createSprite("stageFront", {-650, 600}, "stagefront")
    setProperty("stageFront.scrollFactor.x", 0.9)
    setProperty("stageFront.scrollFactor.y", 0.9)
    add("stageFront")

    createSprite("stageCurtains", {-500, -300}, "stagecurtains")
    setProperty("stageCurtains.scrollFactor.x", 1.3)
    setProperty("stageCurtains.scrollFactor.y", 1.3)
    add("stageCurtains")
end