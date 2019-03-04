{% if stage == "reminder_sent" %}

    {% if not error %}
        <h2 class="z-logon-title">{_ Check your email _}</h2>
        <p>{_ We have sent an email with a link to reset your password to _}: <b>{{ email|escape }}</b></p>
        <p>{_ If you do not receive the email within a few minutes, please check your spam folder. _}</p>
    {% elseif error == `ratelimit` %}
        <h2 class="z-logon-title">{_ Too many retries _}</h2>
        <p>
            {_ Please try again in _}
            {% with m.ratelimit.timeout as seconds %}
                {% if seconds == 3600 %}{_ an hour _}.
                {% elseif seconds > 3600 %}{{ ((seconds+3599)/3600)|round }} {_ hours _}.
                {% else %}{{ (seconds / 60)|round }} {_ minutes _}.
                {% endif %}
            {% endwith %}
        </p>
    {% else %}
        <h2 class="z-logon-title">{_ Could not send email _}</h2>
        <p>{_ Please try again later. _}</p>
    {% endif %}

    {% if not m.acl.user %}
        <p><a class="btn btn-primary" href="{% url logon %}" id="back_to_logon">{_ Back to sign in _}</a></p>
    {% else %}
        <p><a id="back_to_logon" class="btn btn-default" href="{% url logon %}">{_ OK _}</a></p>
    {% endif %}

{% elseif stage == "verification_pending" %}

    <h2 class="z-logon-title">{_ Verify your account _}</h2>
    <p>{_ You're almost done! To make sure you are really you, we ask you to confirm your account from your email address. _}</p>
    <form id="verification_form" method="POST" action="postback">
        <button class="btn btn-primary" type="submit">{_ Send Verification Message _}</button>
    </form>
    {% wire id="verification_form" postback={send_verification user_id=user_id} %}

{% elseif stage == "verification_sent" %}

    <h2 class="z-logon-title">{_ Check your email _}</h2>
    <p>{_ In the email you will find instructions on how to confirm your account. _}</p>
    <p>{_ If you do not receive the email within a few minutes, please check your spam folder. _}</p>

{% elseif stage == "verification_error" %}

    <h2 class="z-logon-title error">{_ Sorry, could not send the verification message. _}</h2>
    <p>{_ We don’t seem to have any valid email address or other electronic communication address of you. _}</p>
    {% if not m.acl.user %}
        <p><a class="btn btn-default" href="{% url logon %}">{_ Back to sign in _}</a></p>
    {% else %}
        <p><a id="{{ #cancel }}" class="btn btn-default" href="#">{_ Cancel _}</a></p>
        {% wire id=#cancel action={redirect back} %}
    {% endif %}

{% elseif stage == "tos_agree" %}

    {% include "_logon_tos_agree_title.tpl" %}
    {% include "_logon_tos_agree_form.tpl" %}

{% elseif stage == "password_expired" %}

    {% include "_logon_expired_form.tpl" %}

{% endif %}
