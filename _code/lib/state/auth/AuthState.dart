import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta_crawller_flutter/_common/model/exception/CommonException.dart';
import 'package:insta_crawller_flutter/_common/util/AuthUtil.dart';
import 'package:insta_crawller_flutter/_common/util/DialogUtil.dart';
import 'package:insta_crawller_flutter/_common/util/LogUtil.dart';
import 'package:insta_crawller_flutter/_common/util/PageUtil.dart';

class AuthStateManager<STATE> {
  AuthState<STATE> authState;
  STATE state;

  AuthStateManager(this.state) : authState = AuthStateSendEmail<STATE>(state);

  Future<void> handle(Map<String, dynamic> data) async {
    authState = await authState.handle(data);
  }
}

abstract class AuthState<STATE> {
  STATE state;

  AuthState(this.state);

  Future<AuthState<STATE>> handle(Map<String, dynamic> data);
}

class AuthStateSendEmail<STATE> extends AuthState<STATE> {
  AuthStateSendEmail(STATE state) : super(state);

  @override
  Future<AuthState<STATE>> handle(Map<String, dynamic> data) async {
    BuildContext context = data['context'];

    DialogUtil.showLoadingDialog(context);
    NeededAuthBehavior neededAuthBehavior =
        await AuthUtil.me.sendEmailVerification(email: data['email']);
    LogUtil.info(
        "AuthStateSendEmail handle neededAuthBehavior:$neededAuthBehavior");
    if (neededAuthBehavior == NeededAuthBehavior.NEED_LOGIN) {
      return AuthStateLogin<STATE>(state);
    } else if (neededAuthBehavior == NeededAuthBehavior.NEED_REGISTRATION) {
      return AuthStateRegistration<STATE>(state);
    } else if (neededAuthBehavior == NeededAuthBehavior.NEED_VERIFICATION) {
      return AuthStateNeedVerification<STATE>(state);
    }
    DialogUtil.dismissLoadingDialog();
    return this;
  }
}

class AuthStateNeedVerification<STATE> extends AuthState<STATE> {
  AuthStateNeedVerification(STATE state) : super(state);

  @override
  Future<AuthState<STATE>> handle(Map<String, dynamic> data) async {
    BuildContext context = data['context'];

    DialogUtil.showLoadingDialog(context);
    await AuthUtil.me.loginWithEmailDefaultPassword(data['email']);
    if (await AuthUtil.me.emailIsVerified()) {
      await AuthUtil.me.delete();
      DialogUtil.dismissLoadingDialog();
      return AuthStateRegistration<STATE>(state);
    } else {
      DialogUtil.dismissLoadingDialog();
      DialogUtil.toastError(data['context'], "이메일 인증이 필요합니다.");
      return this;
    }
  }
}

class AuthStateRegistration<STATE> extends AuthState<STATE> {
  AuthStateRegistration(STATE state) : super(state);

  @override
  Future<AuthState<STATE>> handle(Map<String, dynamic> data) async {
    BuildContext context = data['context'];
    String email = data['email'];
    String password = data['password'];
    String passwordConfirm = data['passwordConfirm'];
    Widget nextPage = data['nextPage'];

    if (email.isEmpty) {
      DialogUtil.toastError(context, "이메일이 비어있습니다");
      return this;
    }

    if (password.isEmpty) {
      DialogUtil.toastError(context, "비밀번호가 비어있습니다");
      return this;
    }

    if (passwordConfirm.isEmpty) {
      DialogUtil.toastError(context, "비밀번호 확인이 비어있습니다");
      return this;
    }

    if (password != passwordConfirm) {
      DialogUtil.toastError(context, "비밀번호가 다릅니다.");
      return this;
    }

    DialogUtil.showLoadingDialog(context);
    //다른 안내는 파이어베이스에서 해준다.
    try {
      await AuthUtil.me.registerWithEmail(email, password);
    } on CommonException catch (e) {
      DialogUtil.dismissLoadingDialog();
      DialogUtil.toastError(context, e.message);
      return this;
    }

    DialogUtil.dismissLoadingDialog();
    DialogUtil.toastInfo(context, "회원가입이 완료되었습니다.");
    PageUtil.goReplacement(context, nextPage);
    return this;
  }
}

class AuthStateLogin<STATE> extends AuthState<STATE> {
  AuthStateLogin(STATE state) : super(state);

  @override
  Future<AuthState<STATE>> handle(Map<String, dynamic> data) async {
    BuildContext context = data['context'];
    String email = data['email'];
    String password = data['password'];
    Widget nextPage = data['nextPage'];

    if (email.isEmpty) {
      DialogUtil.toastError(context, "이메일이 비어있습니다");
      return this;
    }

    if (password.isEmpty) {
      DialogUtil.toastError(context, "비밀번호가 비어있습니다");
      return this;
    }

    DialogUtil.showLoadingDialog(context);
    //다른 안내는 파이어베이스에서 해준다.
    try {
      await AuthUtil.me.loginWithEmail(email, password);
    } on CommonException catch (e) {
      DialogUtil.dismissLoadingDialog();
      DialogUtil.toastError(context, e.message);
      return this;
    }

    PageUtil.goReplacement(context, nextPage);
    DialogUtil.dismissLoadingDialog();
    return this;
  }
}
