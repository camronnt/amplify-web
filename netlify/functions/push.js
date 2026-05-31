
exports.handler = async function(event) {

  if(event.httpMethod !== 'POST') return {statusCode:405,body:'Method not allowed'};

  try{

    const body = JSON.parse(event.body);

    const resp = await fetch('https://api.groq.com/openai/v1/chat/completions',{

      method:'POST',

      headers:{'Content-Type':'application/json','Authorization':'Bearer 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'},

      body: JSON.stringify(body)

    });

    const data = await resp.json();

    return {statusCode:200,headers:{'Access-Control-Allow-Origin':'*'},body:JSON.stringify(data)};

  }catch(e){

    return {statusCode:500,body:JSON.stringify({error:e.message})};

  }

};

