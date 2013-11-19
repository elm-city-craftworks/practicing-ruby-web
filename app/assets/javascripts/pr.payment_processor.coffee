class PR.PaymentProcessor
  constructor: (@key) ->
    Stripe.setPublishableKey @key
    $(document).on 'submit', "#payment-form", this.formSubmit

    $('.card-number').focus()

    $(document).on 'click', 'a#show-cvc-help', (e) ->
      $.facebox { div: '#cvc-help' }, 'cvc-help'
      e.preventDefault()

    $(document).on 'click', 'a.update-cc', (e) ->
      $.facebox { div: '#update-credit-card' }, 'update-credit-card'
      e.preventDefault()

    $(document).on 'click', '#change-billing-interval', (e) ->
      $.facebox { div: '#confirm-interval-change' }, 'confirm-interval-change'
      e.preventDefault()

  formSubmit: (event) =>
    event.preventDefault();

    @form = $(event.currentTarget)

    # disable the submit button to prevent repeated clicks
    $('.submit-button').attr "disabled", "disabled"
    $(".payment-errors").text ""

    this.createSpinner()

    Stripe.createToken {
        number:    @form.find('.card-number').val(),
        cvc:       @form.find('.card-cvc').val(),
        exp_month: @form.find('.card-expiry-month').val(),
        exp_year:  @form.find('.card-expiry-year').val()
    }, this.responseHandler
  responseHandler: (status, response) =>
    if (response.error)
      this.logError response.error.message
    else
      # token contains id, last4, and card type
      token = response['id']
      # insert the token into the form so it gets submitted to the server
      @form.append "<input type='hidden' name='stripeToken' value='#{token}'/>"

      if this.couponExists()
        this.checkCoupon()
      else
        this.submitPayment()
  couponCode: =>
    return $('#coupon').val()
  couponExists: =>
    if $('#coupon').length && @couponCode != ""
      return true
    else
      return false
  checkCoupon: =>
    $.getJSON '/registration/coupon_valid', { coupon: @couponCode }, (data) =>
      if data.coupon_valid
        this.submitPayment()
      else
        this.logError "Coupon code is not valid"
  submitPayment: =>
    @form.get(0).submit()
  logError: (message) =>
    @spinner.stop()
    $(".payment-errors").text      message
    $(".submit-button").removeAttr "disabled"
  createSpinner: =>
    spinnerTarget  = @form.find('#processing-spinner')[0]

    spinnerOpts = {
      lines: 9,
      length: 4,
      width: 3,
      radius: 5,
      corners: 0.8,
      hwaccel: true,
      speed: 1.6
    };

    @spinner = new Spinner(spinnerOpts).spin(spinnerTarget)
