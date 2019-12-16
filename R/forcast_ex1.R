
nottem

dts <-ts(nottem,start =c(1920,1),end=c(1939,12),frequency = 12)

options(repr.plot.width = 4, repr.plot.height = 4)
plot(dts)

stationary_dts <- decompose(dts)
plot(stationary_dts)

acf(dts)

dts_arima <- arima(dts, order=c(3,0,0))
dts_arima



library(forecast)
dts_fit <- forecast(dts_arima)
dts_fit
plot(dts_fit)

dts_autoarima <- auto.arima(dts)
dts_autoarima


dts_fit <- forecast(dts_autoarima)
dts_fit
plot(dts_fit)

