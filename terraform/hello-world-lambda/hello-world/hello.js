// Lambda function code

module.exports.handler = async (event) => {
  console.log('Event: ', event);
  let responseMessage = 'Hello, Someone!';

  if (event.queryStringParameters && event.queryStringParameters['Name']) {
    responseMessage = 'This is the API: ' + event.queryStringParameters['Name'] + '!';
  }

  return {e
    statusCode: 200,
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      message: responseMessage,
    }),
  }
}
