# AppworksSchoolHw8
## 作業1題目
請 clone 這份[合約](https://github.com/HappyFeet07/RugPullHW/tree/master)
試圖在 test 中升級後 rug pull 搶走所有 user 的 usdc 和 usdt

## 作業1回答
撰寫TradingCenterV2，其中在initialize時，加入owner，以便在withdraw的時候限制onlyOnwer可以執行。
TradingCenterV2相比V1增加Withdraw()，因為在題目中，已將user的USDT和USDC 全部approve給ProxyTradingCenter，故Withdraw函數中僅使用兩次transferFrom，分別把user的USDT和USDC轉走。

## 作業2題目
請假裝你是 USDC 的 Owner，嘗試升級 [usdc](https://etherscan.io/address/0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48#code)，並完成以下功能
製作一個白名單
只有白名單內的地址可以轉帳
白名單內的地址可以無限 mint token

## 作業2回答
為了模擬USDC Owner升級合約，必須先Fork Mainnet，在此使用以下指令，模擬在Ethereum主網第N個區塊
```
vm.createFork
vm.selectFork
vm.rollFork
```
