class PaymentController {
  bool canPay({required double saldo, required double monto}) {
    if (monto < 0.01) {
      return false;
    }
    if (monto > saldo) {
      return false;
    }
    return true;
  }
}
