abstract class CommonState{

}
class CommonInitialState extends CommonState{}
class CommonLoadingState extends CommonState{}
class CommonSuccessState<Type> extends CommonState{
  final Type data;
  CommonSuccessState({required this.data});
}

class CommonErrorState extends CommonState{
  final String msg;
  CommonErrorState({required this.msg});
}