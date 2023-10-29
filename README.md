# AppworksSchoolHw8
# 作業1題目
請 clone 這份[合約](https://github.com/HappyFeet07/RugPullHW/tree/master)
試圖在 test 中升級後 rug pull 搶走所有 user 的 usdc 和 usdt

# 作業1回答
撰寫TradingCenterV2，其中在initialize時，加入owner，以便在withdraw的時候限制onlyOnwer可以執行。
TradingCenterV2相比V1增加Withdraw()，因為在題目中，已將user的USDT和USDC 全部approve給ProxyTradingCenter，故Withdraw函數中僅使用兩次transferFrom，分別把user的USDT和USDC轉走。

# 作業2題目
