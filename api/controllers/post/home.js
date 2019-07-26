module.exports = async function (req, res) {
    console.log("home page")

    const allPosts = await Post.find()

    res.view('pages/home',
        { allPosts }
    )
}