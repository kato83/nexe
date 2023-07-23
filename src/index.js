exports.handler = async (event) => {

  // handle challenge
  const challenge = JSON.parse(event?.body || '{}').challenge;
  if (challenge) {
    const body = {
      challenge: challenge
    };
    const response = {
      statusCode: 200,
      body: JSON.stringify(body)
    };
    return response;
  }

  // ログに書き込む
  console.log(JSON.stringify(event));

  // 200を返す。
  const response = {
    statusCode: 200,
    body: JSON.stringify('Hello from Lambda!'),
  };
  return response;

};
