
//dummy database
// const post1 = {
//     id: 1,
//     title: "Title 1",
//     body: "Here is my body 1"
// }

// const post2 = {
//     id: 2,
//     title: "Title 2",
//     body: "Here is my body 2"
// }

// const post3 = {
//     id: 3,
//     title: "Title 3",
//     body: "Here is my body 3"
// }

// const allPosts = [post1, post2, post3]

module.exports = {
    posts: async function (req, res) {
        try {
            const posts = await Post.find()
            res.send(posts)
        } catch{
            res.serverError(err.toString())
        }

        // Post.find().exec(function (err, posts) {
        //     if (err) {
        //         return res.serverError(err.toString())
        //     }
        //     res.send(posts)
        // })
    },

    // create: function (req, res) {

    //     const title = req.body.title
    //     const postBody = req.body.postBody

    //     sails.log.debug('my title' + title)
    //     sails.log.debug('my body' + postBody)

    //     Post.create({ title: title, body: postBody }).exec(function (err) {
    //         if (err) {
    //             return res.serverError(err.toString())
    //         }
    //         console.log("Finished: creating post object")
    //         return res.redirect('./home')
    //         // return res.end()
    //     })
    // },

    // delete: async function (req, res) {
    //     const postId = req.param('postId')
    //     try {
    //         await Post.destroy({ id: postId })
    //         res.send("Finished deleting post")
    //     } catch{
    //         return res.serverError(err.toString())
    //     }
    // },

    findById: function (req, res) {
        const postId = req.param('postId')
        // const allPosts = await Post.find()
        // const filteredPosts = allPosts.filter(p => p.id === postId)

        // const filteredPosts = allPosts.filter(p => { return p.id == postId })
        // if (filteredPosts.length > 0) {
        //     res.send(filteredPosts[0])
        // } else {
        //     res.send('Failed to find post by id: ' + postId)
        // }
        res.end()
    }
}