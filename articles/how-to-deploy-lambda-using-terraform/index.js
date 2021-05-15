
// index.js

const perform = async ({ event, ctx }) => {
	await new Promise((response, reject) => {
		setTimeout(() => {
			console.log(`Hello world from: ${ctx.functionName} :: ${ctx.awsRequestId}`)
			response()
		}, 5000)
	})
}

exports.handler = async (event, ctx) => await perform({ event, ctx })


