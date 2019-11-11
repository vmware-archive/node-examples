import Link from "next/link";

var cfenv
var gemfire
var cacheFactory
var region

let locatorServer = "localhost"
let locatorPort = 10334
let poolName = "myPool"
let username = "root"
let password = "root-password"
let regionName = "exampleRegion"


function initGemfire() {
  gemfire = eval('require("gemfire")')
  cfenv = eval('require("cfenv")')
  initCloudFoundryConfig()
  initCacheFactory()
}

function initCloudFoundryConfig(){
  /* Get Pivotal Cloud Cache settings from CF if they're available */
  if ((cfenv !== undefined) && (Object.keys(cfenv.getAppEnv().services).length > 0)) {

    /* Default to the first p-cloudcache service */
    let vcap_pcc = cfenv.getAppEnv().services["p-cloudcache"][0];

    /* Configure the locator address and port */
    var locatorStringParts = vcap_pcc.credentials.locators[0].split(/[\[\]]+/)
    locatorServer = locatorStringParts[0];
    locatorPort = Number(locatorStringParts[1]);

    /* Default to the first p-cloudcache user's credentials */
    username = vcap_pcc.credentials.users[0].username;
    password = vcap_pcc.credentials.users[0].password;
    console.log("Found PCC Credentials for user: " + username)

    /* p-cloudcache default example region */
    regionName = "example_partition_region"
  }
}

async function initCacheFactory() {
  /* Create a cacheFactory with authentication to connect to PCC */
  cacheFactory = gemfire.createCacheFactory()
  cacheFactory.set('log-level', 'none')
  cacheFactory.set('log-file', 'gemfire.log')
  cacheFactory.setAuthentication((properties, server) => {
      properties['security-username'] = username
      properties['security-password'] = password
    }, () => {}
  )
}

async function getPageCounter() {
  region = await getRegion()

  /* Do the get on the region */
  const page_count = await region.get("page_counter")

  /* Put page_counter asynchronously */
  region.put("page_counter", page_count+1)

  return page_count
}

async function getRegion() {
  /* Block until the cache creation is complete */
  let cache = await cacheFactory.create()
  let poolFactory = cache.getPoolManager().createFactory()
  poolFactory.addLocator(locatorServer, locatorPort);
  poolFactory.create(poolName)
  return cache.createRegion(regionName, {type: 'CACHING_PROXY', poolName: poolName})
}

const CounterComponent = ({page_counter, renderer}) => (
  <div className='card'>

    <h3>Count: {page_counter}</h3>
    <p>Rendered {renderer}-side!</p>

    <p> <a href="/">Re-render on server</a> </p>
    <p> <Link href='/'><a>Re-render in browser</a></Link> </p>

    <style jsx>{`
      .card{padding:18px 18px 24px;width:220px;text-align:left;text-decoration:none;color:#434343;border:1px solid #9b9b9b}.card:hover{border-color:#067df7}.card h3{margin:0;color:#067df7;font-size:18px}.card p{margin:0;padding:12px 0 0;font-size:13px;color:#333}
    `}</style>

  </div>
)

const Home = props => (
  <div>
    <div className='hero'>
      <h1 className='title'><i>Pivotal Cloud Cache</i> <br/> + Next.js!</h1>
      <p className='description'>
        An example page-counter built with <a href="https://nextjs.org/">Next.js</a> and the <i>Pivotal Cloud Cache</i> <a href="http://gemfire-node.docs.pivotal.io/20/gemfire-nodeclient/about-client-users-guide.html">Node.js client.</a>
      </p>

      <div className='row'>
        <CounterComponent page_counter={props.page_counter} renderer={props.renderer}/>
      </div>
    </div>

    <style jsx>{`
      :global(body){margin:0;font-family:-apple-system,BlinkMacSystemFont,Avenir Next,Avenir,Helvetica,sans-serif;text-align:center}nav{display:flex;align-items:center;justify-content:center}nav.ul{display:flex;align-items:center;justify-content:center}nav>ul{padding:4px 50px}nav>li{display:flex;font-size:13px}nav>a{color:#067df7;text-decoration:none;font-size:13px;display:flex;padding:6px 20px}.hero{width:100%;color:#333}.title{margin:0;width:100%;padding-top:30px;padding-bottom:30px;line-height:1.15;font-size:48px;background-color:#00b5a3;color:#fefefe}.row{max-width:880px;margin:20px auto 40px;display:flex;flex-direction:row;justify-content:space-around}
    `}</style>
  </div>
)

Home.getInitialProps = async function({req}){
  /* Customize initial rendering */
  if(req){
    /* Rendering on server */
    initGemfire()
    let page_count = await getPageCounter()
    return {
      renderer: "server",
      page_counter: page_count
    }
  } else {
    /* Rendering on client */
    return {
      renderer: "client",
      page_counter: "N/A"
    }
  }
}

export default Home
