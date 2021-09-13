const { create } = require('ipfs-http-client');
const ipfs = create({host: 'localhost', port: 5001});
export default ipfs;