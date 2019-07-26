module.exports = {


  friendlyName: 'Create',


  description: 'Create post.',


  inputs: {
    title: {
      description: 'Title of post object',
      type: 'string',
      required: true
    },
    postBody: {
      description: 'body of post object',
      type: 'string',
      required: true
    }
  },


  exits: {

  },


  fn: async function (inputs) {
    console.log("we are now in post/create")
    
    await Post.create({ title: inputs.title, body: inputs.postBody })
           
    return;

  }


};
