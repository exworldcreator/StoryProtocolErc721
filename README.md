# StoryProtocolErc721
The project was created for everyone who wants to easily and quickly create their NFT collection on Story Protocol.

## Project installation

1. Create a directory and initialize ```yarn init```
2. Set up foundry ```forge init --force```
3. Open your foundry.toml and replace it with this:
```
[profile.default]
out = 'out'
libs = ['node_modules', 'lib']
cache_path  = 'forge-cache'
gas_reports = ["*"]
optimizer = true
optimizer_runs = 20000
test = 'test'
solc = '0.8.26'
fs_permissions = [{ access = 'read', path = './out' }, { access = 'read-write', path = './deploy-out' }]
evm_version = 'cancun'
```
4. Let's clear the project of debris ```rm -rf lib/ .github/``` ```rm src/Counter.sol test/Counter.t.sol script/Counter.s.sol```
5. Installing Dependencies 
```
yarn add @story-protocol/protocol-core@https://github.com/storyprotocol/protocol-core-v1
yarn add @story-protocol/protocol-periphery@https://github.com/storyprotocol/protocol-periphery-v1
yarn add @openzeppelin/contracts
yarn add @openzeppelin/contracts-upgradeable
yarn add erc6551
yarn add solady
yarn add -D https://github.com/dapphub/ds-test
yarn add -D github:foundry-rs/forge-std#v1.7.6
```
6. Create remmapings.txt and paste the following:
```
@openzeppelin/=node_modules/@openzeppelin/
@storyprotocol/core/=node_modules/@story-protocol/protocol-core/contracts/
@storyprotocol/periphery/=node_modules/@story-protocol/protocol-periphery/contracts/
erc6551/=node_modules/erc6551/
forge-std/=node_modules/forge-std/src/
ds-test/=node_modules/ds-test/src/
@storyprotocol/test/=node_modules/@story-protocol/protocol-core/test/foundry/
@solady/=node_modules/solady/
```