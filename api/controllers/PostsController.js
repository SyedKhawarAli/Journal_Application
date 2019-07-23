
//dummy database
const post1 = {
    id: 1,
    title: "Title 1",
    body: "Here is my body 1"
}

const post2 = {
    id: 2,
    title: "Title 2",
    body: "Here is my body 2"
}

const post3 = {
    id: 3,
    title: "Title 3",
    body: "Here is my body 3"
}

const allPosts = [post1, post2, post3]

module.exports = {
    posts: function (req, res) {
        res.send(allPosts)
    },

    create: function (req, res) {

        const title = req.param('title')
        const body = req.param('body')

        sails.log.debug(title + " " + body)

        const post = {
            id: allPosts.length + 1,
            title: title,
            body: body
        }

        allPosts.push(post)
        res.send("created a post")
    },

    findById: function (req, res) {
        const postId = req.param('postId')
        // const filteredPosts = allPosts.filter(p => { return p.id == postId })
        const filteredPosts = allPosts.filter(p => p.id == postId)
        if (filteredPosts.length > 0) {
            res.send(filteredPosts[0])
        } else {
            res.send('Failed to find post by id: ' + postId)
        }
    }
}