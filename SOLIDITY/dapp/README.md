1) Open 2 terminals.
2) Term1: cd backend; npm run i; npm run node;
3) Term2: cd backend; npm run deploy-local;
4) Rename `backend/.env_example` to `backend/.env` ( fill with personal URL and PrivKeys if you are going to deploy to testnet, if not, just leave it as it is. ).
4) Copy `backend/artifacts/contracts/TransgerContract.sol/TransgerContract.js` contents into `frontend/ContractMeta.js`'s `ContractMeta` variable.
5) Check index.js JS code, update address and methods if you changed the contract methods.
6) Open index.html with Live Server ( VSCode extension ), right click on file > open on Live Server.
7) Connect wallet ( metamask )
8) Interact with frontend.